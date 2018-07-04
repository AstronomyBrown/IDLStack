/**
 * UnionType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package nvo_region;

public class UnionType  extends nvo_region.RegionType  implements java.io.Serializable {
    private nvo_region.RegionType[] region;

    public UnionType() {
    }


    /**
     * Gets the region value for this UnionType.
     * 
     * @return region
     */
    public nvo_region.RegionType[] getRegion() {
        return region;
    }


    /**
     * Sets the region value for this UnionType.
     * 
     * @param region
     */
    public void setRegion(nvo_region.RegionType[] region) {
        this.region = region;
    }

    public nvo_region.RegionType getRegion(int i) {
        return this.region[i];
    }

    public void setRegion(int i, nvo_region.RegionType value) {
        this.region[i] = value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof UnionType)) return false;
        UnionType other = (UnionType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.region==null && other.getRegion()==null) || 
             (this.region!=null &&
              java.util.Arrays.equals(this.region, other.getRegion())));
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
        if (getRegion() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getRegion());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getRegion(), i);
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
        new org.apache.axis.description.TypeDesc(UnionType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:nvo-region", "unionType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("region");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-region", "Region"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-region", "regionType"));
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
