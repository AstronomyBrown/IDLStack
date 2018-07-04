/**
 * ConvexType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package nvo_region;

public class ConvexType  extends nvo_region.ShapeType  implements java.io.Serializable {
    private nvo_region.ConstraintType[] constraint;

    public ConvexType() {
    }


    /**
     * Gets the constraint value for this ConvexType.
     * 
     * @return constraint
     */
    public nvo_region.ConstraintType[] getConstraint() {
        return constraint;
    }


    /**
     * Sets the constraint value for this ConvexType.
     * 
     * @param constraint
     */
    public void setConstraint(nvo_region.ConstraintType[] constraint) {
        this.constraint = constraint;
    }

    public nvo_region.ConstraintType getConstraint(int i) {
        return this.constraint[i];
    }

    public void setConstraint(int i, nvo_region.ConstraintType value) {
        this.constraint[i] = value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ConvexType)) return false;
        ConvexType other = (ConvexType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.constraint==null && other.getConstraint()==null) || 
             (this.constraint!=null &&
              java.util.Arrays.equals(this.constraint, other.getConstraint())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = super.hashCode();
        if (getConstraint() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getConstraint());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getConstraint(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ConvexType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:nvo-region", "convexType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("constraint");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-region", "Constraint"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-region", "constraintType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
