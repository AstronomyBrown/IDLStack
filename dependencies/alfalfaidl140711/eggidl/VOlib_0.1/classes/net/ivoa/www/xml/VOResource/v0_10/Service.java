/**
 * Service.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.VOResource.v0_10;

public class Service  extends net.ivoa.www.xml.VOResource.v0_10.Resource  implements java.io.Serializable {
    private net.ivoa.www.xml.VOResource.v0_10._interface[] _interface;

    public Service() {
    }


    /**
     * Gets the _interface value for this Service.
     * 
     * @return _interface
     */
    public net.ivoa.www.xml.VOResource.v0_10._interface[] get_interface() {
        return _interface;
    }


    /**
     * Sets the _interface value for this Service.
     * 
     * @param _interface
     */
    public void set_interface(net.ivoa.www.xml.VOResource.v0_10._interface[] _interface) {
        this._interface = _interface;
    }

    public net.ivoa.www.xml.VOResource.v0_10._interface get_interface(int i) {
        return this._interface[i];
    }

    public void set_interface(int i, net.ivoa.www.xml.VOResource.v0_10._interface value) {
        this._interface[i] = value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof Service)) return false;
        Service other = (Service) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this._interface==null && other.get_interface()==null) || 
             (this._interface!=null &&
              java.util.Arrays.equals(this._interface, other.get_interface())));
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
        if (get_interface() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(get_interface());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(get_interface(), i);
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
        new org.apache.axis.description.TypeDesc(Service.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Service"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("_interface");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "interface"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Interface"));
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
